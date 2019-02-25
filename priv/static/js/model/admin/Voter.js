Ext.define('Votr.model.admin.Voter', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'name', type: 'string'},
        {name: 'ext_id', type: 'string'},
        {name: 'voted', type: 'number'},
        {name: 'weight', type: 'number'},
        {name: 'identity_cards'},
        {name: 'access_code', type: 'string'},
        {name: 'email', type: 'string'},
        {name: 'phone', type: 'string'},
        {name: 'postal_address', type: 'string'},
        {name: 'updated_at', type: 'date'}
    ],
    proxy: {
        type: 'rest',
        url: '../api/admin/voters',
        reader: { type: 'json', rootProperty: 'voters' }
    }
});
