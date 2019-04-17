SELECT associations2.object_id, associations2.term_id,
       associations2.cat_ID, associations2.term_taxonomy_id
FROM (SELECT objects_tags.object_id, objects_tags.term_id,
     wp_cb_tags2cats.cat_ID, categories.term_taxonomy_id
FROM (SELECT wp_term_relationships.object_id,
     wp_term_taxonomy.term_id, wp_term_taxonomy.term_taxonomy_id
FROM wp_term_relationships
LEFT JOIN wp_term_taxonomy ON
     wp_term_relationships.term_taxonomy_id =
     wp_term_taxonomy.term_taxonomy_id
ORDER BY object_id ASC, term_id ASC) 
AS objects_tags
LEFT JOIN wp_cb_tags2cats ON objects_tags.term_id =
     wp_cb_tags2cats.tag_ID
LEFT JOIN (SELECT wp_term_relationships.object_id,
     wp_term_taxonomy.term_id as cat_ID,
     wp_term_taxonomy.term_taxonomy_id
FROM wp_term_relationships
LEFT JOIN wp_term_taxonomy ON
     wp_term_relationships.term_taxonomy_id =
     wp_term_taxonomy.term_taxonomy_id
WHERE wp_term_taxonomy.taxonomy = 'category'
GROUP BY object_id, cat_ID, term_taxonomy_id
ORDER BY object_id, cat_ID, term_taxonomy_id) 
AS categories on wp_cb_tags2cats.cat_ID = categories.term_id
WHERE objects_tags.term_id = wp_cb_tags2cats.tag_ID
GROUP BY object_id, term_id, cat_ID, term_taxonomy_id
ORDER BY object_id ASC, term_id ASC, cat_ID ASC) 
AS associations2
LEFT JOIN categories ON associations2.object_id =
     categories.object_id
WHERE associations2.cat_ID <> categories.cat_ID
GROUP BY object_id, term_id, cat_ID, term_taxonomy_id
ORDER BY object_id, term_id, cat_ID, term_taxonomy_id
