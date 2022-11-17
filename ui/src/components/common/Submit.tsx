import styled from '@emotion/styled';

import { colors } from '../../constants';

const Submit = styled.button`
  width: 100%;
  height: 40px;

  cursor: pointer;

  border: 1px solid ${colors.lightBlack};
  border-radius: 10px;

  background-color: white;

  font-size: 18px;
  font-family: 'Roboto', sans-serif;
  font-weight: 100;

  &:hover {
    background-color: ${colors.whiteHover};
  }

  &:active {
    background-color: ${colors.whiteActive};
  }
`;

export default Submit;
