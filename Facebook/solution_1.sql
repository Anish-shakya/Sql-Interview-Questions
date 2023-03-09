select p.page_id 
from pages p
left join page_likes l ON p.page_id = l.page_id
where l.page_id is NULL
ORDER BY p.page_id ASC
