Ext.define('Votr.store.admin.Voters', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.admin.Voter',
    data: [
        { name: 'Voter 1', voted: 0 },
        { name: 'Voter 2', voted: 0 },
        { name: 'Voter 3', voted: 0 },
        { name: 'Voter 4', voted: 0 }
    ]
});
