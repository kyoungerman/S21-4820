SELECT t3.title
    FROM a03_tags as t1
    JOIN a03_title_to_tag as t2 on t1.id = t2.tag_id
    JOIN a03_title as t3 on t2.title_id = t3.id and words @@ to_tsquery('configuration')
WHERE t1.tag = 'trigger'
;