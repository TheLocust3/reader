import React from 'react';
import styled from '@emotion/styled';

import { colors } from '../constants';

const Container = styled.div`
  width: 100%;
  height: 100%;

  display: flex;
  align-items: center;
  justify-content: center;
  vertical-align: middle;
`

const LoginContainer = styled.div`
  width: 400px;
  height: 275px;

  padding-top: 20px;
  padding-bottom: 20px;
  padding-left: 30px;
  padding-right: 30px;

  border: 1px solid ${colors.black};
  border-radius: 10px;
`;

const Title = styled.div`
  padding-top: 5px;
  padding-bottom: 35px;

  font-size: 36px;
`;

const Label = styled.div`
  padding-bottom: 3px;
`;

const Textbox = styled.input`
  display: block;
  box-sizing: border-box;

  width: 100%;
  height: 35px;

  padding-left: 10px;
  padding-right: 10px;

  margin-bottom: 15px;

  border: 1px solid ${colors.lightBlack};
  border-radius: 5px;

  font-size: 15px;
  font-family: 'Roboto', sans-serif;
  font-weight: 100;
`;

const Spacer = styled.div`
  height: 10px;
`;

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

function Login() {
  return (
    <Container>
      <LoginContainer>
        <Title>Sign In</Title>

        <Label>Email:</Label>
        <Textbox type="text" />

        <Label>Password:</Label>
        <Textbox type="password" />
        <Spacer />

        <Submit>Submit</Submit>
      </LoginContainer>
    </Container>
  );
}

export default Login;
