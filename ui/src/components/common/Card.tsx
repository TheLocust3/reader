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
  border-radius: 5px;

  box-shadow: 0px 0px 1px ${colors.lightBlack};
`;

export default Card;
