Ext.define('Votr.model.Color', {
    extend: 'Ext.data.Model',
    idProperty: 'value',
    fields: [
        {name: 'rank', type: 'integer'},
        {name: 'hue', type: 'integer'},
        {name: 'value', type: 'string'},
        {name: 'text', type: 'string'}
    ]
});
