Ext.define('Votr.controller.Voter', {
    extend: 'Ext.app.Controller',
    views: [
        'voter.Main',
        'voter.Ballots',
        'voter.Ballot',
        'voter.BallotInfo',
        'voter.Candidate',
        'voter.RankField'
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
