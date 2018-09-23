Ext.define('Votr.model.voter.Candidate', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'name', type: 'string'},
        {name: 'description', type: 'string'},
        {name: 'method', type: 'string'},
        {name: 'status', type: 'integer'}
    ]
});
