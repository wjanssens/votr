Ext.define('Votr.model.voter.Ballot', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'title'},
        {name: 'description'},
        {name: 'method', type: 'string'},
        {name: 'electing', type: 'integer'},
        {name: 'anonymous', type: 'boolean'},
        {name: 'shuffled', type: 'boolean'},
        {name: 'mutable', type: 'boolean'},
        {name: 'candidates'}
    ]
});
