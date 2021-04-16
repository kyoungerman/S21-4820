INSERT INTO a03_title (id, title, body) 
    SELECT id, title, body 
    FROM a02_title;

INSERT INTO a03_tags (id, tag) 
    SELECT id, tag
    FROM a02_tags;

INSERT INTO a03_title_to_tag (id, title_id, tag_id) 
    SELECT id, title_id, tag_id
    FROM a02_title_to_tag;    