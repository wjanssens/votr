Ext.define('Votr.model.Language', {
    extend: 'Ext.data.Model',
    idProperty: 'value',
    fields: [
        {name: 'rank', type: 'integer'},
        {name: 'value', type: 'string'},
        {name: 'text', type: 'string'}
    ]
});
