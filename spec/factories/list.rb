FactoryGirl.define do
  factory :todo_list, class: List do
    trello_list_id 'list000'
    name 'To Do'
    trello_board_id 'board001'
  end
  factory :in_progress_list, class: List do
    trello_list_id 'list002'
    name 'In Progress'
    trello_board_id 'board001'
  end
  factory :done_list, class: List do
    trello_list_id 'list003'
    name 'In Progress'
    trello_board_id 'board001'
  end
end
