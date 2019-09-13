Ext.define('Votr.model.admin.ResultCandidate', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'name', type: 'string'},
        {name: 'status', type: 'string'},
        {name: 'votes', type: 'number'},
        {name: 'surplus', type: 'number'},
        {name: 'exhausted', type: 'number'}
    ]
});
