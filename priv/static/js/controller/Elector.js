Ext.define('Votr.controller.Elector', {
    extend: 'Ext.app.Controller',
    views: [
        'Wards', 'Ward', 'Ballots', 'Ballot', 'Candidates', 'Candidate', 'Voters', 'Voter'
    ],
    models: [
        'Ward', 'Ballot', 'Voter', 'Candidate'
    ],
    stores: [
        'Wards', 'Ballots', 'Voters', 'Candidates'
    ]
})
