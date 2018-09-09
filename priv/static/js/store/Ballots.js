Ext.define('Votr.store.Ballots', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Ballot',
    data: [
        { title: { default: 'Ballot 1' }, description: { default: 'Description 1' }, method: 'SSTV', quota: 'droop', electing: 1, candidates: 6 , shuffle: true},
        { title: { default: 'Ballot 2' }, description: { default: 'Description 2' }, method: 'SSTV', quota: 'hare',  electing: 2, candidates: 12, shuffle: true},
        { title: { default: 'Ballot 3' }, description: { default: 'Description 3' }, method: 'MSTV', quota: 'droop', electing: 3, candidates: 18, shuffle: true },
        { title: { default: 'Ballot 4' }, description: { default: 'Description 4' }, method: 'SSTV', quota: 'droop', electing: 4, candidates: 24, shuffle: true }
    ]
});
