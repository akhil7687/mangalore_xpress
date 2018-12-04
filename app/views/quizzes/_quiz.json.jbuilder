json.extract! quiz, :id, :quiz_name, :status, :created_at, :updated_at
json.url quiz_url(quiz, format: :json)
