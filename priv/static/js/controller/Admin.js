Ext.define('Votr.controller.Admin', {
    extend: 'Ext.app.Controller',
    views: [
        'admin.Wards',
        'admin.Ward',
        'admin.Ballots',
        'admin.Ballot',
        'admin.Candidates',
        'admin.Candidate',
        'admin.Voters',
        'admin.Voter'
    ],
    models: [
        'Ward', 'Ballot', 'Voter', 'Candidate'
    ],
    stores: [
        'Wards', 'Ballots', 'Voters', 'Candidates'
    ]
})
