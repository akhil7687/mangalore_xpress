json.extract! question, :id, :quiz_id, :qn, :optn_a, :optn_b, :optn_c, :optn_d, :correct_ans, :created_at, :updated_at
json.url question_url(question, format: :json)
