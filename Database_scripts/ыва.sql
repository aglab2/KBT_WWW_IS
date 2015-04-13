IF OBJECT_ID('Cul_Insert', 'TR') IS NOT NULL
	DROP TRIGGER Cul_Insert
GO

GO
IF OBJECT_ID('Table2', 'V') IS NOT NULL
	DROP VIEW Table2
GO

CREATE VIEW Table2 AS
	SELECT Address.id AS address_id, parent_id, type_id, Address.name as address_name,
		AddressType.id AS address_type_id, AddressType.name AS address_type_name
	FROM Address, AddressType
	WHERE Address.type_id = AddressType.id


GO
SELECT * FROM Table2

INSERT Table2(address_type_name) VALUES ('Barabuga')
INSERT Table2(parent_id, type_id, address_name) VALUES (1, IDENT_CURRENT('AddressType'), 'Ãðîçíûsssé')

SELECT * FROM Table2
GO

IF OBJECT_ID('Cul_Insert', 'TR') IS NOT NULL
	DROP TRIGGER Cul_Insert
GO
CREATE TRIGGER Cul_Insert
ON Table2
INSTEAD OF INSERT
AS
	INSERT Table2(address_type_name)
		SELECT inserted.address_type_name
		FROM inserted

	INSERT Table2(parent_id, type_id, address_name)
		SELECT inserted.address_type_id, IDENT_CURRENT('AddressType'), inserted.address_name
		FROM inserted
GO