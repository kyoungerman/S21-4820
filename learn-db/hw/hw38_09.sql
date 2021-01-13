SELECT doc_id, document_title 
	FROM indexed_docs  
	WHERE document_tokens @@ to_tsquery('die & democracy')
;  
