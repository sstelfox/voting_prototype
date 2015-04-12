module Voting
  class App
    helpers PostHelpers

    get '/questions/?' do
      erb :'questions/index', locals: { questions: Question.all }
    end

    get '/questions/new/?', auth: nil do
      question = Question.new(
        answers: (params[:answer_count] || 3).to_i.times.map { Answer.new },
        voters: (params[:voter_count] || 3).to_i.times.map { Voter.new }
      )
      erb :'questions/new', locals: { question: question }
    end

    post '/questions/new/?', auth: nil do
      question = Question.new(params[:question])

      if question.save
        flash[:success] = 'You\'ve successfully created a ' \
          "<a href='/questions/#{question.id}'>new question</a>."
        redirect '/questions'
      else
        flash.now[:alert] = 'There was an error in your submission.'
        erb :'questions/new', locals: { question: question }
      end
    end

    get '/questions/:id/?' do
      halt(404) unless (question = Question.get(params[:id]))

      erb :'questions/show', locals: { question: question }
    end

    post '/questions/:id/new_answer/?' do
      halt(404) unless (question = Question.get(params[:id]))

      text = params[:answer][:text]

      if question.released?
        flash[:alert] = 'Answers can only be added to unreleased questions.'
        redirect "/questions/#{question.id}/"
      end

      if question.answers.all(text: text).any?
        flash[:alert] = "Answers already exists for this question with that text '#{text}'."
        redirect "/questions/#{question.id}/"
      end

      if Answer.create(question: question, text: text)
        flash[:success] = "Answer successfully added with text #{text}."
      else
        flash[:alert] = "Failed to add answer with text #{text}."
      end

      redirect "/questions/#{question.id}/"
    end

    post '/questions/:id/new_voter/?' do
      halt(404) unless (question = Question.get(params[:id]))

      email = params[:voter][:email]

      if question.released?
        flash[:alert] = 'Voters can only be added to unreleased questions.'
        redirect "/questions/#{question.id}/"
      end

      if question.voters.all(email: email).any?
        flash[:alert] = "Voter already exists for this question with email '#{email}'."
        redirect "/questions/#{question.id}/"
      end

      if Voter.create(question: question, email: email)
        flash[:success] = "Voter successfully added with email #{email}."
      else
        flash[:alert] = "Failed to added voter with email #{email}."
      end

      redirect "/questions/#{question.id}/"
    end

    get '/questions/:id/close/?', auth: nil do
      halt(404) unless (question = Question.get(params[:id]))

      question.close_voting!
      redirect "/questions/#{question.id}/"
    end

    get '/questions/:id/release/?', auth: nil do
      halt(404) unless (question = Question.get(params[:id]))

      question.release_for_voting!
      redirect "/questions/#{question.id}/"
    end

    get '/questions/:id/vote/:token/?' do
      halt(404) unless (question = Question.get(params[:id]))
      halt(403) unless (voter = question.voters.all(token: params[:token]).first)

      erb :'questions/vote', locals: { question: question, voter: voter }
    end

    post '/questions/:question_id/vote/:token/?' do
      halt(404) unless (question = Question.get(params[:question_id]))

      unless question.released?
        flash[:alert] = 'No votes are allowed until the question has been released!'
        redirect "/questions/#{question.id}/"
      end

      if question.closed?
        flash[:alert] = 'No votes are allowed after the question has closed!'
        redirect "/questions/#{question.id}/"
      end

      halt(403) unless (voter = question.voters.all(token: params[:token]).first)

      if voter.answer!(params[:answer_ids].map(&:to_i))
        redirect "/questions/#{question.id}/"
      else
        erb :'questions/vote', locals: { question: question, voter: voter }
      end
    end
  end
end
