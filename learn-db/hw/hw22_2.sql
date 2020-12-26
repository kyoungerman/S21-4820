WITH RECURSIVE subordinates AS (
		SELECT
			id,
			manager_id,
			name
		FROM tree_example
		WHERE id = 2
	UNION
		SELECT
			e.id,
			e.manager_id,
			e.name
		FROM tree_example e
		INNER JOIN subordinates s ON s.id = e.manager_id
) SELECT * FROM subordinates
;
