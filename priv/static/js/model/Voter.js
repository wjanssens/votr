Ext.define('Votr.model.Voter', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'ext_id', type: 'string'},
        {name: 'voted', type: 'number'},
        {name: 'identity_card', type: 'string'},
        {name: 'dob', type: 'string'},
        {name: 'email', type: 'string'},
        {name: 'phone', type: 'string'},
        {name: 'postal_address', type: 'string'}
    ]
});
