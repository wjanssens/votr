Ext.define('Votr.controller.Admin', {
    extend: 'Ext.app.Controller',
    views: [
        'admin.Dashboard',
        'admin.Wards',
        'admin.Ward',
        'admin.Ballots',
        'admin.Ballot',
        'admin.Candidates',
        'admin.Candidate',
        'admin.Voters',
        'admin.Voter',
        'admin.Results',
        'admin.Result',
        'admin.Profile'
    ],
    models: [
        'admin.Ward',
        'admin.Ballot',
        'admin.Voter',
        'admin.Candidate',
        'admin.ResultRound',
        'admin.ResultCandidate',
        'Language'
    ],
    stores: [
        'admin.Results',
        'Languages',
        'Colors'
    ]
})
