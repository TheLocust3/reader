import styled from '@emotion/styled';

import { colors } from '../../constants';

const Textbox = styled.input`
  display: block;
  box-sizing: border-box;

  width: 100%;
  height: 35px;

  padding-left: 10px;
  padding-right: 10px;

  border: 1px solid ${colors.lightBlack};
  border-radius: 3px;

  font-size: 15px;
  font-family: 'Roboto', sans-serif;
  font-weight: 100;
`;

export default Textbox;
