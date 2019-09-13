Ext.define('Votr.store.Results', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Result',
    groupField: 'round',
    groupDir: 'desc',
    sorters: [{property: 'votes', direction: 'desc'},'name'],
    data: [
        { round: 5, threshold: 26.0, candidates: [
            { name: 'Monkey',    votes: 26.0, status: 'elected' },
            { name: 'Gorilla',   votes: 26.0, status: 'elected' },
            { name: 'Tarsier',   votes: 0.0,  status: 'excluded' },
            { name: 'Lynx',      votes: 0,    status: 'excluded' },
            { name: 'Tiger',     votes: 26.0, status: 'elected',  surplus: 8.0 },
            { name: 'Exhausted', votes: 14.0 },
        ] },
        { round: 4, threshold: 26.0, candidates: [
            { name: 'Monkey',    votes: 26.0, status: 'elected' },
            { name: 'Gorilla',   votes: 26.0, status: 'elected' },
            { name: 'Tarsier',   votes: 0.0,  status: 'excluded'},
            { name: 'Lynx',      votes: 0,    status: 'excluded', surplus: 13.0 },
            { name: 'Tiger',     votes: 34.0, received: 13.0 },
            { name: 'Exhausted', votes: 14.0 },
        ] },
        { round: 3, threshold: 26.0, candidates: [
            { name: 'Monkey',    votes: 26.0, status: 'elected' },
            { name: 'Gorilla',   votes: 26.0, status: 'elected' },
            { name: 'Tarsier',   votes: 0,    status: 'excluded', surplus: 5.0  },
            { name: 'Lynx',      votes: 13 },
            { name: 'Tiger',     votes: 21 },
            { name: 'Exhausted', votes: 14.0, received: 9.0 },
        ] },
        { round: 2, threshold: 26.0, candidates: [
            { name: 'Monkey',    votes: 26.0, status: 'elected' },
            { name: 'Gorilla',   votes: 26.0, status: 'elected', surplus: 2.0 },
            { name: 'Tarsier',   votes: 5  },
            { name: 'Lynx',      votes: 13 },
            { name: 'Tiger',     votes: 21 },
            { name: 'Exhausted', votes: 9.0, received: 2.0 },
        ] },
        { round: 1, threshold: 26.0, candidates: [
            { name: 'Monkey',    votes: 26.0, status: 'elected', surplus: 7.0 },
            { name: 'Gorilla',   votes: 28 },
            { name: 'Tarsier',   votes: 5  },
            { name: 'Lynx',      votes: 13 },
            { name: 'Tiger',     votes: 21 },
            { name: 'Exhausted', votes: 7.0, received: 7.0 },
        ] },
        { round: 0, threshold: 26.0, candidates: [
            { name: 'Monkey',    votes: 33 },
            { name: 'Gorilla',   votes: 28 },
            { name: 'Tarsier',   votes: 5  },
            { name: 'Lynx',      votes: 13 },
            { name: 'Tiger',     votes: 21 },
            { name: 'Exhausted', votes: 0  }
        ]}
    ]
});


