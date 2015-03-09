require 'ipaddr'

class Voting::App
  get '/questions/?' do
    erb :'questions/index', :locals => {questions: Voting::Question.all}
  end

  get '/questions/:id/?' do
    erb :'questions/show', :locals => {question: Voting::Question.get(params[:id])}
  end

  get '/questions/new/?', :auth => nil do
    erb :'questions/new', :locals => {question: Voting::Question.new}
  end

  post '/questions/new/?', :auth => nil do
    question = params[:question] || {}
    answer_attributes = question.delete(:answer_attributes) || []

    question = Voting::Question.new(question)
    question.answers = answer_attributes.map { |a| Voting::Answer.new(a) }

    if question.save
      flash[:success] = "You've successfully created a <a href='/questions/#{question.id}'>new question</a>."
      redirect '/questions'
    else
      flash[:error] = "There was an error in your submission."
      erb :'questions/new', :locals => {question: question}
    end
  end
end
