Ext.define('Votr.model.Ballot', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'title', type: 'string'},
        {name: 'description', type: 'string'},
        {name: 'method', type: 'string'},
        {name: 'elect', type: 'integer'},
        {name: 'color', type: 'string'},
        {name: 'shuffle', type: 'boolean'},
        {name: 'mutable', type: 'boolean'}
    ]
});
