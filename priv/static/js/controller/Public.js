Ext.define('Votr.controller.Public', {
    extend: 'Ext.app.Controller',
    views: [
        'public.Main',
        'public.Ballots',
        'public.Ballot',
    ],
    models: [
        'Ballot',
        'Candidate',
        'Result'
    ],
    stores: [
        'Ballots',
        'Results'
    ]
})
