Ext.define('Votr.store.voter.Ballots', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.voter.Ballot',
    data: [
        {
            id: '1',
            title: 'STV',
            description: 'This is a sample STV ranked ballot',
            method: 'stv',
            electing: 3,
            anonymous: true,
            mutable: false,
            shuffled: true,
            candidates: [
                {index: 4, withdrawn: false, name: 'Guy F.', description: 'Conservative Party', id: '1234a1234a'},
                {index: 2, withdrawn: false, name: 'Guy F.', description: 'Democratic Party', id: '1234a1234a'},
                {index: 3, withdrawn: false, name: 'Guy F.', description: 'Liberal Party', id: '1234a1234a'},
                {index: 1, withdrawn: true, name: 'Guy F.', description: 'Green Party', id: '1234a1234a'}
            ]
        },
        {
            id: '2',
            title: 'Plurality',
            description: 'This is a sample plurality ballot',
            method: 'plurality',
            electing: 1,
            anonymous: true,
            mutable: false,
            shuffled: true,
            candidates: [
                {index: 2, withdrawn: false, name: 'Guy F.', description: 'Republican', id: '1234a1234a'},
                {index: 3, withdrawn: false, name: 'Guy F.', description: 'Democrat', id: '1234a1234a'},
                {index: 1, withdrawn: true, name: 'Guy F.', description: 'Independent', id: '1234a1234a'}
            ]
        }, {
            id: '3',
            title: 'Approval',
            description: 'This is a sample approval ballot',
            method: 'approval',
            electing: 1,
            anonymous: true,
            mutable: false,
            shuffled: true,
            candidates: [
                {index: 2, withdrawn: false, name: 'Sushi', id: '1234a1234a'},
                {index: 3, withdrawn: false, name: 'Pizza', id: '1234a1234a'},
                {index: 1, withdrawn: true, name: 'Burgers', id: '1234a1234a'},
                {index: 5, withdrawn: false, name: 'Chinese', id: '1234a1234a'},
                {index: 4, withdrawn: false, name: 'Italian', id: '1234a1234a'}
            ]
        }
    ]
});
