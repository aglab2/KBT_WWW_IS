SELECT *
FROM EntityAttributeDict, History
WHERE EntityAttributeDict.id = History.attribute_id
ORDER BY History.instance_id