Ext.define('Votr.model.Ballot', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'title', type: 'string'},
        {name: 'description', type: 'string'},
        {name: 'method', type: 'string'},
        {name: 'start', type: 'date'},
        {name: 'end', type: 'date'},
        {name: 'electing', type: 'integer'},
        {name: 'anonymous', type: 'boolean'},
        {name: 'shuffled', type: 'boolean'},
        {name: 'mutable', type: 'boolean'},
        {name: 'public', type: 'boolean'},
        {name: 'candidates'}
    ]
});
