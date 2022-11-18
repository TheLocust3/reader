import styled from '@emotion/styled';

import { colors } from '../../constants';

const Card = styled.div`
  width: 400px;
  height: 300px;
  background-color: white;

  padding-top: 20px;
  padding-bottom: 20px;
  padding-left: 30px;
  padding-right: 30px;

  border: 1px solid ${colors.black};
  border-radius: 10px;

  box-shadow: 0px 0px 3px ${colors.lightBlack};
`;

export default Card;
