CREATE INDEX if not exists indexed_docs_tsv_1 ON indexed_docs USING GIN (document_tokens);  
