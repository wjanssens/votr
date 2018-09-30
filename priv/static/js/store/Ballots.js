Ext.define('Votr.store.Ballots', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Ballot',
    data: [
        {
            id: '1',
            title: 'STV',
            description: 'This is a sample STV ranked ballot. This is a sample STV ranked ballot. This is a sample STV ranked ballot. This is a sample STV ranked ballot.',
            start: '2018-01-01T08:00:00Z',
            end: '2018-01-01T20:00:00Z',
            ward: 'Test',
            method: 'scottish_stv',
            electing: 3,
            anonymous: true,
            mutable: false,
            shuffled: true,
            public: true,
            candidates: [
                {index: 4, name: 'Guy F.', description: 'Conservative Party', id: '1234a1234a'},
                {index: 2, name: 'Guy F.', description: 'Democratic Party', id: '1234a1234a'},
                {index: 3, name: 'Guy F.', description: 'Liberal Party', id: '1234a1234a'},
                {index: 1, name: 'Guy F.', description: 'Green Party', id: '1234a1234a', status: 'withdrawn'}
            ]
        },
        {
            id: '2',
            title: 'Plurality',
            description: 'This is a sample plurality ballot',
            start: '2018-01-01T08:00:00Z',
            end: '2018-01-01T20:00:00Z',
            method: 'plurality',
            electing: 1,
            anonymous: true,
            mutable: false,
            shuffled: true,
            public: true,
            candidates: [
                {index: 2, name: 'Guy F.', description: 'Republican', id: '1234a1234a'},
                {index: 3, name: 'Guy F.', description: 'Democrat', id: '1234a1234a'},
                {index: 1, name: 'Guy F.', description: 'Independent', id: '1234a1234a'}
            ]
        }, {
            id: '3',
            title: 'Approval',
            description: 'This is a sample approval ballot',
            start: '2018-01-01T08:00:00Z',
            end: '2018-01-01T20:00:00Z',
            method: 'approval',
            electing: 1,
            anonymous: true,
            mutable: false,
            shuffled: true,
            public: true,
            candidates: [
                {index: 2, name: 'Sushi', id: '1234a1234a'},
                {index: 3, name: 'Pizza', id: '1234a1234a'},
                {index: 1, name: 'Burgers', id: '1234a1234a', status: 'withdrawn'},
                {index: 5, name: 'Chinese', id: '1234a1234a'},
                {index: 4, name: 'Italian', id: '1234a1234a'}
            ]
        }
    ]
});
