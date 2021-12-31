import { injectGlobal } from '@emotion/css';

import { colors } from './constants';

injectGlobal`
    html, body, #root {
        margin: 0;
        padding: 0;
        width: 100%;
        height: 100%;
        position: relative;
        color: ${colors.black};
        font-family: 'Roboto', sans-serif;
        font-weight: 100;
    }

    h1, h2, h3, h4, h5 {
        font-family: 'Roboto Slab', serif;
        font-weight: 100;
        margin: 0;
    }

    p {
        margin: 0;
        font-size: 14px;
        font-weight: 100;
    }
`;
