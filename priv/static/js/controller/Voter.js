Ext.define('Votr.controller.Voter', {
    extend: 'Ext.app.Controller',
    views: [
        'voter.Main',
        'voter.Ballots',
        'voter.Ballot',
        'voter.BallotInfo',
        'voter.BallotResult',
        'voter.Candidate',
        'voter.RankField'
    ],
    models: [
        'voter.Ballot',
        'voter.Candidate',
        'voter.Result'
    ],
    stores: [
        'voter.Ballots',
        'voter.Results'
    ]
})
