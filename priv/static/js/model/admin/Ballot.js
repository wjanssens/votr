Ext.define('Votr.model.admin.Ballot', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'ext_id', type: 'string'},
        {name: 'title'},
        {name: 'description'},
        {name: 'method', type: 'string'},
        {name: 'quota', type: 'string'},
        {name: 'electing', type: 'integer'},
        {name: 'color', type: 'string'},
        {name: 'shuffle', type: 'boolean'},
        {name: 'mutable', type: 'boolean'},
        {name: 'lang', type: 'string', defaultValue: 'default' }
    ]
});
