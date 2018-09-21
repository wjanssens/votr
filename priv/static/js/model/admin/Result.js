Ext.define('Votr.model.admin.Result', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'candidate', type: 'string'},
        {name: 'round', type: 'integer'},
        {name: 'status', type: 'string'},
        {name: 'votes', type: 'number'},
        {name: 'surplus', type: 'number'},
        {name: 'exhausted', type: 'number'}
    ]
});
