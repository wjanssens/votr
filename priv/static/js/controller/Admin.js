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
        'admin.Ward',
        'admin.Ballot',
        'admin.Voter',
        'admin.Candidate',
        'admin.Result',
        'Language'
    ],
    stores: [
        'admin.Wards',
        'admin.Ballots',
        'admin.Voters',
        'admin.Candidates',
        'admin.Results',
        'Languages'
    ]
})
