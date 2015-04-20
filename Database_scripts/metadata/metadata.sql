---1
SELECT sysobjects.name
	FROM sysobjects, sysusers
	WHERE xtype = 'U'
	AND sysobjects.uid = sysusers.uid
	AND sysusers.name = 'dbo';

---2
SELECT sysobjects.name, syscolumns.name, syscolumns.isnullable, systypes.name, syscolumns.length
	FROM syscolumns, sysobjects, sysusers, systypes
	WHERE syscolumns.id = sysobjects.id
	AND sysobjects.xtype = 'U'
	AND sysobjects.uid = sysusers.uid
	AND sysusers.name = 'dbo'
	AND syscolumns.xtype = systypes.xtype

---3
SELECT t.name, k.name, k.xtype
	FROM sysobjects t, sysobjects k, sysusers
	WHERE (k.xtype = 'F'
	OR k.xtype = 'PR')
	AND k.parent_obj = t.id
	AND k.uid = sysusers.uid
	AND sysusers.name = 'dbo'

---4
SELECT fk_name.name, ft.name, rt.name
	FROM sysobjects fk_name, sysreferences, sysobjects ft, sysobjects rt, sysusers
	WHERE fk_name.id = sysreferences.constid
	AND sysreferences.fkeyid = ft.id
	AND sysreferences.rkeyid = rt.id
	AND fk_name.uid = sysusers.uid
	AND sysusers.name = 'dbo'

---5
SELECT sysobjects.name, syscomments.text
	FROM sysobjects, syscomments, sysusers
	WHERE syscomments.id = sysobjects.id
	AND sysobjects.xtype = 'V'
	AND sysobjects.uid = sysusers.uid
	AND sysusers.name = 'dbo'

---6
SELECT tr.name, t.name
	FROM sysobjects tr, sysobjects t, sysusers
	WHERE tr.xtype = 'TR'
	AND t.xtype = 'U'
	AND tr.parent_obj = t.id
	AND tr.uid = sysusers.uid
	AND sysusers.name = 'dbo'