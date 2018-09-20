Ext.define('Votr.store.Results', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Result',
    groupField: 'round',
    groupDir: 'desc',
    data: [
        { round: 5, name: 'Monkey',    votes: 26.0, status: 'elected' },
        { round: 5, name: 'Gorilla',   votes: 26.0, status: 'elected' },
        { round: 5, name: 'Tarsier',   votes: 0.0,  status: 'excluded', surplus: 5.0  },
        { round: 5, name: 'Lynx',      votes: 0,    status: 'excluded', surplus: 13.0 },
        { round: 5, name: 'Tiger',     votes: 34.0, status: 'elected',  surplus: 8.0 },
        { round: 5, name: 'Exhausted', votes: 14.0 },

        { round: 4, name: 'Monkey',    votes: 26.0, status: 'elected' },
        { round: 4, name: 'Gorilla',   votes: 26.0, status: 'elected' },
        { round: 4, name: 'Tarsier',   votes: 0.0,  status: 'excluded', surplus: 5.0  },
        { round: 4, name: 'Lynx',      votes: 0,    status: 'excluded', surplus: 13.0 },
        { round: 4, name: 'Tiger',     votes: 34.0, received: 13.0 },
        { round: 4, name: 'Exhausted', votes: 14.0 },

        { round: 3, name: 'Monkey',    votes: 26.0, status: 'elected' },
        { round: 3, name: 'Gorilla',   votes: 26.0, status: 'elected' },
        { round: 3, name: 'Tarsier',   votes: 0,    status: 'excluded', surplus: 5.0  },
        { round: 3, name: 'Lynx',      votes: 13 },
        { round: 3, name: 'Tiger',     votes: 21 },
        { round: 3, name: 'Exhausted', votes: 14.0, received: 9.0 },

        { round: 2, name: 'Monkey',    votes: 26.0, status: 'elected' },
        { round: 2, name: 'Gorilla',   votes: 26.0, status: 'elected', surplus: 2.0 },
        { round: 2, name: 'Tarsier',   votes: 5  },
        { round: 2, name: 'Lynx',      votes: 13 },
        { round: 2, name: 'Tiger',     votes: 21 },
        { round: 2, name: 'Exhausted', votes: 9.0, received: 2.0 },

        { round: 1, name: 'Monkey',    votes: 26.0, status: 'elected', surplus: 7.0 },
        { round: 1, name: 'Gorilla',   votes: 28 },
        { round: 1, name: 'Tarsier',   votes: 5  },
        { round: 1, name: 'Lynx',      votes: 13 },
        { round: 1, name: 'Tiger',     votes: 21 },
        { round: 1, name: 'Exhausted', votes: 7.0, received: 7.0 },

        { round: 0, name: 'Monkey',    votes: 33 },
        { round: 0, name: 'Gorilla',   votes: 28 },
        { round: 0, name: 'Tarsier',   votes: 5  },
        { round: 0, name: 'Lynx',      votes: 13 },
        { round: 0, name: 'Tiger',     votes: 21 },
        { round: 0, name: 'Exhausted', votes: 0  }

    ]
});


