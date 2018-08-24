Ext.define('Votr.store.Voters', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Voter',
    data: [
        { name: 'Voter 1', voted: 0 },
        { name: 'Voter 2', voted: 0 },
        { name: 'Voter 3', voted: 0 },
        { name: 'Voter 4', voted: 0 }
    ]
});
