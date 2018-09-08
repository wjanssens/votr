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
        'admin.Voter',
        'admin.Results',
        'admin.Result'
    ],
    models: [
        'Ward', 'Ballot', 'Voter', 'Candidate', 'Language', 'Result'
    ],
    stores: [
        'Wards', 'Ballots', 'Voters', 'Candidates', 'Languages', 'Results'
    ]
})
