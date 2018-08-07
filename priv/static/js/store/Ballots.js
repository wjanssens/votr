Ext.define('Votr.store.Ballots', {
    extend: 'Ext.data.TreeStore',
    model: 'Votr.model.Ballot',
    data: [
        { title: 'Ballot 1', description: "Description 1", electing: 1, candidates: 6 },
        { title: 'Ballot 2', description: "Description 2", electing: 2, candidates: 12 },
        { title: 'Ballot 3', description: "Description 3", electing: 3, candidates: 18 },
        { title: 'Ballot 4', description: "Description 4", electing: 4, candidates: 24 }
    ]
});
