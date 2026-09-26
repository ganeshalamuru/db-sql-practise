-- Task (Q165): Using STRING_SPLIT, parse the comma-separated tag list 'electronics,kitchen,laptops,books' into individual rows. Return the distinct trimmed tags as tag.
-- Requirement: Order by tag ascending.
SELECT DISTINCT TRIM(value) AS tag
FROM STRING_SPLIT('electronics,kitchen,laptops,books', ',')
ORDER BY tag;
