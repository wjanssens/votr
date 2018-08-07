Ext.define('Votr.controller.Main', {
    extend: 'Ext.app.Controller',
    views: [
        'Main', 'Wards', 'Ward', 'Ballots', 'Ballot', 'Voters', 'Voter'
    ],
    models: [
        'Ward', 'Ballot', 'Voter'
    ],
    stores: [
        'Wards', 'Ballots', 'Voters'
    ]
})
