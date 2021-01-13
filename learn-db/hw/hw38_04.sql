SELECT to_tsvector('The quick brown fox jumped over the lazy dog')  
    @@ to_tsquery('fox')
;
