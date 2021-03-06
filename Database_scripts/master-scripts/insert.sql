USE [kbt-project];

INSERT INTO AddressType (name) VALUES ('City');
exec addAttribute2Dict @entity_name='Address',    @attribute_name='name'
exec addAttribute2Dict @entity_name='Team',       @attribute_name='name'
exec addAttribute2Dict @entity_name='Team',       @attribute_name='phone'
exec addAttribute2Dict @entity_name='Team',       @attribute_name='email'
exec addAttribute2Dict @entity_name='Team',       @attribute_name='captain_id'
exec addAttribute2Dict @entity_name='Team',       @attribute_name='address_id'
exec addAttribute2Dict @entity_name='Player',     @attribute_name='team_id'
exec addAttribute2Dict @entity_name='Player',     @attribute_name='name'
exec addAttribute2Dict @entity_name='Tournament', @attribute_name='name'
exec addAttribute2Dict @entity_name='Tournament', @attribute_name='address_id'
exec addAttribute2Dict @entity_name='Tournament', @attribute_name='password'
exec addAttribute2Dict @entity_name='Question',   @attribute_name='validity_criterion'
exec addAttribute2Dict @entity_name='Answer',     @attribute_name='is_valid'
exec addAttribute2Dict @entity_name='ExternalT',  @attribute_name='value'