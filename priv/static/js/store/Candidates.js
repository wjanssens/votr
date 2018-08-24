Ext.define('Votr.store.Candidates', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Candidate',
    data: [
        { name: 'Candidate 1', desc: 'Description 1', withdrawn: false, votes: 65, percentage: 0.1, status: 'elected', round: 1 },
        { name: 'Candidate 2', desc: 'Description 1', withdrawn: false, votes: 24, percentage: 0.1, status: 'excluded', round: 2 },
        { name: 'Candidate 3', desc: 'Description 1', withdrawn: false, votes: 94, percentage: 0.1, status: 'elected', round: 3 },
        { name: 'Candidate 4', desc: 'Description 1', withdrawn: false, votes: 31, percentage: 0.1, status: 'excluded', round: 4 }
    ]
});
