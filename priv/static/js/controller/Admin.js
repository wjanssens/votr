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
        'admin.Result',
        'admin.Profile'
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
        'admin.Results',
        'Languages',
        'Colors'
    ]
})
