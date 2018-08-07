Ext.define('Votr.store.Voters', {
    extend: 'Ext.data.TreeStore',
    model: 'Votr.model.Voter',
    data: [
        { ext_id: 'Voter 1', voted: 0 },
        { ext_id: 'Voter 2', voted: 0 },
        { ext_id: 'Voter 3', voted: 0 },
        { ext_id: 'Voter 4', voted: 0 }
    ]
});
