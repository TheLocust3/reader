import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import styled from '@emotion/styled';

import Card from './common/Card'
import Submit from './common/Submit'
import Textbox from './common/Textbox'

import Users from '../api/users';

const Container = styled.div`
  width: 100%;
  height: 100%;

  display: flex;
  align-items: center;
  justify-content: center;
  vertical-align: middle;
`

const Title = styled.div`
  padding-top: 5px;
  padding-bottom: 35px;

  font-size: 36px;
`;

const ErrorLabel = styled.div`
  height: 30px;

  font-size: 14px;
`;

const Label = styled.div`
  padding-bottom: 3px;
`;

const Spacer = styled.div`
  height: 15px;
`;

function Login() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const onSubmit = (event: any) => {
    event.preventDefault();
    Users.login(email, password)
      .then(() => navigate('/'))
      .catch(() => setError('Invalid email/password'));
  }

  return (
    <Container>
      <Card>
        <Title>Sign In</Title>

        <form onSubmit={onSubmit}>
          <Label>Email:</Label>
          <Textbox type="text" onChange={(event) => setEmail(event.target.value)} required />
          <Spacer />

          <Label>Password:</Label>
          <Textbox type="password" onChange={(event) => setPassword(event.target.value)} required />
          
          <ErrorLabel>{error}</ErrorLabel>

          <Submit>Submit</Submit>
          <input type="submit" style={{ display: "none" }} />
        </form>
      </Card>
    </Container>
  );
}

export default Login;
